task InstallBuildDependencies -Jobs {
    Install-Module platyPs -Scope CurrentUser -AllowPrerelease -ErrorAction Stop
    Install-Module psdocker -Scope CurrentUser -AllowPrerelease -ErrorAction Stop
    Install-Module PsMermaidTools -Scope CurrentUser -AllowPrerelease -ErrorAction Stop
    Install-Module PsDac -Scope CurrentUser -AllowPrerelease -AllowClobber -ErrorAction Stop
}

task InstallTestDependencies -Jobs {
    Install-Module PsDockerMermaid -Scope CurrentUser -AllowPrerelease -ErrorAction Stop
    Install-Module PsDac -Scope CurrentUser -AllowPrerelease -AllowClobber -ErrorAction Stop
    Install-Module psdocker -Scope CurrentUser -AllowPrerelease -ErrorAction Stop
    Install-Module Invoke-MsBuild -Scope CurrentUser -AllowPrerelease -ErrorAction Stop
}, Testdata.Create

task InstallReleaseDependencies -Jobs {
}
