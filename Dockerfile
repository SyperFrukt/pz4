FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY ["pz4.csproj", "./"]
RUN dotnet restore "pz4.csproj"

COPY . .
RUN dotnet build "pz4.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "pz4.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
EXPOSE 8080

ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production

COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "pz4.dll"]