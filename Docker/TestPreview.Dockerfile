FROM scrthq/powershell:preview
SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
COPY ["./Docker/", "/source/"]
WORKDIR /source
ENTRYPOINT [ "pwsh", "-command", ". ./build.ps1 -Task Test" ]
