# First stage: Build the .NET code
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

# Copy the project files
COPY . .

# Build the project
RUN dotnet build FHIR/src/Microsoft.Health.Fhir.Anonymizer.R4.CommandLineTool -c Release

# Second stage: Set up the runtime environment for .NET, Mono (v6.12+), and Python
FROM mcr.microsoft.com/dotnet/runtime:6.0

# Install Python, pip, pythonnet, and Mono
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    pip3 install pythonnet>=3.0.4 fastapi uvicorn

WORKDIR /app

ENV PYTHONPATH=/app;/lib/netlib

COPY --from=build /app/FHIR/src/Microsoft.Health.Fhir.Anonymizer.R4.CommandLineTool/bin/Release/net6.0 /lib/netlib

ENV PYTHONNET_RUNTIME=coreclr
#ENTRYPOINT ["dotnet", "Microsoft.Health.Fhir.Anonymizer.R4.CommandLineTool.dll"]

# Copy the FastAPI Python code
COPY ./fastapi-app /app/fastapi-app

# Expose the FastAPI port
EXPOSE 8000

# Command to run FastAPI
CMD ["uvicorn", "fastapi-app.main:app", "--host", "0.0.0.0", "--port", "8000"]
