FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

# Copy the project files
COPY . .

# Build the project
RUN dotnet build FHIR/src/Microsoft.Health.Fhir.Anonymizer.R4.CommandLineTool -c Release

FROM mcr.microsoft.com/dotnet/runtime:6.0

# Install Python, pip, pythonnet, and Mono
RUN apt-get update && \
    apt-get install -y python3 python3-pip mono-complete && \
    pip3 install pythonnet fastapi uvicorn

WORKDIR /app

COPY --from=build /app/FHIR/src/Microsoft.Health.Fhir.Anonymizer.R4.CommandLineTool/bin/Release/net6.0 /app

#ENTRYPOINT ["dotnet", "Microsoft.Health.Fhir.Anonymizer.R4.CommandLineTool.dll"]

# Copy the FastAPI Python code
COPY ./fastapi-app /app/fastapi-app

# Expose the FastAPI port
EXPOSE 8000

# Command to run FastAPI
CMD ["uvicorn", "fastapi-app.main:app", "--host", "0.0.0.0", "--port", "8000"]
