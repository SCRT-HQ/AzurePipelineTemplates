FROM scrthq/powershell
SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
COPY [".", "/source/"]
WORKDIR /source
ENTRYPOINT [ "pwsh", "-command", ". ./build.ps1 -Task Test" ]
