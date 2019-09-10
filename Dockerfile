# Pull down the latest preview version of the image
FROM scrthq/powershell:preview
# Set the default shell for the container
SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
# Copy current repo contents into the container's /source directory
COPY [".", "/source/"]
# Set the default working directory to the repo source folder
WORKDIR /source
# Add the entry script which will kick off the tests when the container is ran
ENTRYPOINT [ "pwsh", "-command", ". ./build.ps1 -Task Test" ]
