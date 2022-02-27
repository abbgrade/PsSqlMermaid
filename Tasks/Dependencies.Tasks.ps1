task InstallBuildDependencies -Jobs {
    Install-Module platyPs, psdocker -ErrorAction Stop
}

task InstallTestDependencies -Jobs {
    Install-Module PsDockerMermaid, PsDac, psdocker -ErrorAction Stop
}

task InstallReleaseDependencies -Jobs {
    Install-Module psdocker -ErrorAction Stop
}
