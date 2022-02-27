
[System.IO.DirectoryInfo] $SqlServerSamplesDirectory = "$PSScriptRoot\..\Test\sql-server-samples"
[string] $WwiSsdtRelativePath = 'samples/databases/wide-world-importers/wwi-ssdt/wwi-ssdt'
[System.IO.DirectoryInfo] $WwiSsdtDirectory = Join-Path $SqlServerSamplesDirectory $WwiSsdtRelativePath

task Testdata.DacPac.WWI.Clean -If ( $SqlServerSamplesDirectory.Exists ) -Jobs {
    Remove-Item $SqlServerSamplesDirectory -Recurse -Force
}

task Testdata.DacPac.WWI.AddSolution -If ( -Not $SqlServerSamplesDirectory.Exists ) -Jobs {
    New-Item $SqlServerSamplesDirectory -ItemType Directory
    Push-Location $SqlServerSamplesDirectory
    git init
    git remote add origin -f https://github.com/microsoft/sql-server-samples.git
    git config core.sparseCheckout true
    Set-Content .git/info/sparse-checkout $WwiSsdtRelativePath
    Pop-Location
}

task Testdata.DacPac.WWI.CheckoutSolution -If ( -Not $WwiSsdtDirectory.Exists ) -Jobs Testdata.DacPac.WWI.AddSolution, {
    Push-Location $SqlServerSamplesDirectory
    git pull --depth=1 origin master
    Pop-Location
}

task Testdata.DacPac.WWI.Create -Jobs Testdata.DacPac.WWI.CheckoutSolution, {
    # # can be enabled if dotnet core build is public and working
    # exec { dotnet build "$SqlServerSamplesDirectory\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\WideWorldImporters.sqlproj" /p:NetCoreBuild=true }

    Import-Module Invoke-MsBuild

    Invoke-MsBuild "$SqlServerSamplesDirectory\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\WideWorldImporters.sqlproj"

    assert ( Test-Path "$SqlServerSamplesDirectory\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac" )
}

task Testdata.Create -Jobs Testdata.DacPac.WWI.Create
