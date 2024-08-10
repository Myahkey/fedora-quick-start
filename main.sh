source ./vars.sh;
source ./funcs.sh;

main () {
    pwdless_sudo;
    import_repos;
    configure_flatpak;
    install_dnf_packages;
    configure_docker;
    configure_v2ray;
    configure_git;
    install_flatpak_packages;
    install_python_packages;
    install_nccm;
    zsh_4_humans;
}

main;
