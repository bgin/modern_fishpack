module type_TridiagonalSolver

    use fishpack_precision, only: &
        wp, & ! Working precision
        ip ! Integer precision

    use, intrinsic :: ISO_Fortran_env, only: &
        stderr => ERROR_UNIT, &
        stdout => OUTPUT_UNIT

    use type_TridiagonalData, only: &
        TriDiagonalData

    use type_Grid, only: &
        Grid

    use type_CenteredGrid, only: &
        CenteredGrid

    use type_StaggeredGrid, only: &
        StaggeredGrid

    use module_genbun, only: &
        genbun

    use module_poistg, only: &
        poistg

    ! Explicit typing only
    implicit none

    ! Everything is private unless stated otherwise
    private
    public :: TridiagonalSolver

    
    type, extends (TridiagonalData), public :: TridiagonalSolver
       !---------------------------------------------------------------
       ! Type components
       !---------------------------------------------------------------
    contains
        !---------------------------------------------------------------
        ! Type-bound procedures
        !---------------------------------------------------------------
        procedure, public :: solve_2d_real_linear_system_staggered
        procedure, public :: solve_2d_real_linear_system_centered
        !---------------------------------------------------------------
    end type TridiagonalSolver


contains

    subroutine solve_2d_real_linear_system_staggered( & ! POISTG
        this, source, solution, error_flag )
        !--------------------------------------------------------------
        ! Dummy arguments
        !--------------------------------------------------------------
        class(TridiagonalSolver), intent(inout) :: this
        real(wp), contiguous,     intent(inout) :: source(:,:)
        real(wp), contiguous,     intent(out)    :: solution(:,:)
        integer(ip), optional,    intent(out)    :: error_flag
        !--------------------------------------------------------------
        ! Local variables
        !--------------------------------------------------------------
        integer(ip)   :: local_error_flag
        !--------------------------------------------------------------

        ! Invoke procedural solver
        associate( &
            nperod => this%Y_BOUNDARY_CONDITION, &
            n => size(source, dim=2 ), &
            mperod => this%X_BOUNDARY_CONDITION, &
            m => size(this%subdiagonal ), &
            a => this%subdiagonal, &
            b => this%diagonal, &
            c => this%superdiagonal, &
            idimy  => size(source, dim=1), &
            y => source, &
            ierror => local_error_flag &
            )
            call poistg( nperod, n, mperod, m, a, b, c, idimy, y, ierror )
        end associate

        ! Address the error flag
        if ( local_error_flag /= 0 ) then
            write( stderr, '(a)') 'ERROR: 2D_REAL_LINEAR_SYSTEM_STAGGERED (POISTG)'
            select case (local_error_flag)
                case(1)
                    write( stderr, '(a)') 'Insufficient number of horizontally staggered grid points'
                    write( stderr, '(a)') 'Fails to satisfy:'
                    write( stderr, '(a)') 'NX >= 2'
                case(2)
                    write( stderr, '(a)') 'Insufficient number of vertically staggered grid points'
                    write( stderr, '(a)') 'Fails to satisfy:'
                    write( stderr, '(a)') 'NY >= 2'
                case(3)
                    write( stderr, '(a)') 'Invalid rank for SOURCE_TERM'
                    write( stderr, '(a)') 'Fails to satisfy:'
                    write( stderr, '(a)') 'size(SOURCE_TERM, dim=1) >= NX'
                case(4)
                    write( stderr, '(a)') 'Invalid boundary condition type in y'
                    write( stderr, '(a)') 'Fails to satisfy:'
                    write( stderr, '(a)') '1 <= Y_BOUNDARY_CONDITION_TYPE <= 4'
                case(5)
                    write( stderr, '(a)') 'Invalid boundary condition type in x'
                    write( stderr, '(a)') 'Fails to satisfy:'
                    write( stderr, '(a)') '0 <= X_BOUNDARY_CONDITION_TYPE <= 1'
                case(6)
                    write( stderr, '(a)') 'Invalid tridiagonal system'
                    write( stderr, '(a)') 'X_BOUNDARY_TYPE = 0 and A(1) /= C(1)'
                    write( stderr, '(a)') 'or B(i) /= B(1) or C(i) /= C(1)'
                    write( stderr, '(a)') 'for some i = 1, 2, ..,NX'
                case(7)
                    write( stderr, '(a)') 'Invalid tridiagonal system'
                    write( stderr, '(a)') 'Y_BOUNDARY_TYPE = 1 and '
                    write( stderr, '(a)') 'A(1) /= 0 or C(NX) \= 0 '
                case(20)
                    write( stderr, '(a)') 'The dynamic allocation of real and or complex WORKSPACE failed'
                    write( stderr, '(a)') 'NX or NY may be too large for your computer'
                case default
                    write( stderr, '(a)') 'Undetermined error flag'
            end select
        end if

        ! Set solution
        associate( &
            nx => size(solution, dim=1), &
            ny => size(solution, dim=2) &
            )
            solution = source( 1:nx, 1:ny )
        end associate


        ! Address optional arguments
        if ( present (error_flag) ) then
            error_flag = local_error_flag
        end if

    end subroutine solve_2d_real_linear_system_staggered


    subroutine solve_2d_real_linear_system_centered( & ! genbun
        this, source, solution, error_flag )
        !--------------------------------------------------------------
        ! Dummy arguments
        !--------------------------------------------------------------
        class(TridiagonalSolver), intent(inout) :: this
        real(wp), contiguous,     intent(inout) :: source(:,:)
        real(wp), contiguous,     intent(out)    :: solution(:,:)
        integer(ip), optional,    intent(out)    :: error_flag
        !--------------------------------------------------------------
        ! Local variables
        !--------------------------------------------------------------
        integer(ip)   :: local_error_flag
        !--------------------------------------------------------------

        ! Invoke procedural solver
        associate( &
            nperod => this%Y_BOUNDARY_CONDITION, &
            n => size(source, dim=2), &
            mperod => this%X_BOUNDARY_CONDITION, &
            m => size(this%subdiagonal ), &
            a => this%subdiagonal, &
            b => this%diagonal, &
            c => this%superdiagonal, &
            idimy => size(source, dim=1), &
            y => source, &
            ierror => local_error_flag &
            )
            call genbun( nperod, n, mperod, m, a, b, c, idimy, y, ierror )
        end associate

        ! Address the error flag
        if ( local_error_flag /= 0 ) then
            write( stderr, '(a)') 'ERROR: 2D_REAL_LINEAR_SYSTEM_CENTERED (GENBUN)'
            select case (local_error_flag)
                case(1)
                    write( stderr, '(a)') 'Insufficient number of horizontally staggered grid points'
                    write( stderr, '(a)') 'Fails to satisfy:'
                    write( stderr, '(a)') 'NX >= 2'
                case(2)
                    write( stderr, '(a)') 'Insufficient number of vertically staggered grid points'
                    write( stderr, '(a)') 'Fails to satisfy:'
                    write( stderr, '(a)') 'NY >= 2'
                case(3)
                    write( stderr, '(a)') 'Invalid rank for SOURCE_TERM'
                    write( stderr, '(a)') 'Fails to satisfy:'
                    write( stderr, '(a)') 'size(SOURCE_TERM, dim=1) >= NX'
                case(4)
                    write( stderr, '(a)') 'Invalid boundary condition type in y'
                    write( stderr, '(a)') 'Fails to satisfy:'
                    write( stderr, '(a)') '0 <= Y_BOUNDARY_CONDITION_TYPE <= 4'
                case(5)
                    write( stderr, '(a)') 'Invalid boundary condition type in x'
                    write( stderr, '(a)') 'Fails to satisfy:'
                    write( stderr, '(a)') '0 <= X_BOUNDARY_CONDITION_TYPE <= 1'
                case(6)
                    write( stderr, '(a)') 'Invalid tridiagonal system'
                    write( stderr, '(a)') 'A(1) /= C(1) or C(i) /= C(1)'
                    write( stderr, '(a)') 'or B(i) /= B(1) '
                    write( stderr, '(a)') 'for some i = 1, 2, ..,NX'
                case(7)
                    write( stderr, '(a)') 'Invalid tridiagonal system'
                    write( stderr, '(a)') 'X_BOUNDARY_TYPE = 1 and '
                    write( stderr, '(a)') 'A(1) /= 0 or C(NX) \= 0 '
                case(20)
                    write( stderr, '(a)') 'The dynamic allocation of real and or complex WORKSPACE failed'
                    write( stderr, '(a)') 'NX or NY may be too large for your computer'
                case default
                    write( stderr, '(a)') 'Undetermined error flag'
            end select
        end if

        ! set solution
        associate( &
            nx => size(solution, dim=1), &
            ny => size(solution, dim=2) &
            )
            solution = source(1:nx, 1:ny)
        end associate

        ! Address optional arguments
        if (present(error_flag)) error_flag = local_error_flag

    end subroutine solve_2d_real_linear_system_centered

end module type_TridiagonalSolver
