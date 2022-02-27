task InstallBuildDependencies -Jobs {
    Install-Module platyPs, psdocker -ErrorAction Stop
}

task InstallTestDependencies -Jobs {
    Install-Module PsDockerMermaid, PsDac, psdocker, Invoke-MsBuild -ErrorAction Stop
}, Testdata.Create

task InstallReleaseDependencies -Jobs {
    Install-Module psdocker -ErrorAction Stop
}
