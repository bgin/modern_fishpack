program test

    use module_blktri, only: &
        blktri_unit_test

    use module_cblktri, only: &
        cblktri_unit_test

    use module_cmgnbn, only: &
        cmgnbn_unit_test

    use module_genbun, only: &
        genbun_unit_test

    use module_hstcrt, only: &
        hstcrt_unit_test

    use module_hstcsp, only: &
        hstcsp_unit_test

    use module_hstcyl, only: &
        hstcyl_unit_test

    use module_hstplr, only: &
        hstplr_unit_test

    use module_hstssp, only: &
        hstssp_unit_test

    use module_hw3crt, only: &
        hw3crt_unit_test

    use module_hwscrt, only: &
        hwscrt_unit_test

    use module_hwscsp, only: &
        hwscsp_unit_test

    use module_hwscyl, only: &
        hwscyl_unit_test

    use module_hwsplr, only: &
        hwsplr_unit_test

    use module_hwsssp, only: &
        hwsssp_unit_test

    use module_pois3d, only: &
        pois3d_unit_test

    use module_poistg, only: &
        poistg_unit_test

    use module_sepeli, only: &
        sepeli_unit_test

    use module_sepx4, only: &
        sepx4_unit_test

    call blktri_unit_test()
    call cblktri_unit_test()
    call cmgnbn_unit_test()
    call genbun_unit_test()
    call hstcrt_unit_test()
    call hstcsp_unit_test()
    call hstcyl_unit_test()
    call hstplr_unit_test()
    call hstssp_unit_test() ! test fails
    call hw3crt_unit_test() ! test fails
    call hwscrt_unit_test()
    call hwscsp_unit_test()
    call hwscyl_unit_test()
    call hwsplr_unit_test()
    call hwsssp_unit_test()
    call pois3d_unit_test() ! test fails
    call poistg_unit_test()
    call sepeli_unit_test()
    call sepx4_unit_test()

end program test
