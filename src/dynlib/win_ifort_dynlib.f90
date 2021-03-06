! win_ifort_dynlib --
!     Implementation for Intel Fortran on Windows of low-level routines
!     that deal with dynamic libraries
!
!     Note:
!     The system functions have the __stdcall calling convention.
!     This clashes with bind(c), so that we need to use the
!     compiler directive approach.
!
module system_dynamic_libraries
    use iso_c_binding
    implicit none

    interface
        function c_load_library( cname )
            !dec$ attributes stdcall             :: c_load_library
            !dec$ alias c_load_library, '_LoadLibraryA@4'
            use iso_c_binding
            character(kind=c_char), dimension(*) :: cname
            integer(kind=c_intptr_t)             :: c_load_library
        end function c_load_library
    end interface

    interface
        function c_get_procedure( handle, cname )
            !dec$ attributes stdcall             :: c_get_procedure
            !dec$ alias c_get_procedure, '_GetProcAddress@8'
            use iso_c_binding
            integer(kind=c_intptr_t)             :: handle
            character(kind=c_char), dimension(*) :: cname
            type(c_funptr)                       :: c_get_procedure
        end function c_get_procedure
    end interface

contains

! system_load_library --
!     Load the library
!
! Arguments:
!     handle         Handle to the library
!     cname          Null-terminated name of the library
!
! Returns:
!     Handle to the library
!
subroutine system_load_library( handle, cname )
    integer(kind=c_long)           :: handle
    character(len=1), dimension(*) :: cname

    handle = c_load_library( cname )
end subroutine system_load_library

! system_get_procedure --
!     Get the procedure
!
! Arguments:
!     handle         Handle to the library
!     cname          Null-terminated name of the procedure
!     cproc          C-style procedure pointer
!     success        Whether successful or not
!
! Returns:
!     Handle to the library
!
subroutine system_get_procedure( handle, cname, cproc, success )
    integer(kind=c_long)           :: handle
    character(len=1), dimension(*) :: cname
    type(c_funptr)                 :: cproc
    logical                        :: success

    cproc = c_get_procedure( handle, cname )

    success = c_associated(cproc)

end subroutine system_get_procedure

end module system_dynamic_libraries
