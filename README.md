# EP2 DevOps - Innovatech Chile

## Objetivo de la evaluacion

Dockerizar frontend + microservicios backend, publicar imagenes en Docker Hub y automatizar despliegue en EC2 via GitHub Actions (rama `deploy`).

## Arquitectura

```
Internet → EC2 Frontend (:3000, Nginx proxy)
              ↓ (subnet privada)
         EC2 Backend (:8081 Ventas, :8082 Despacho)
              ↓
         RDS MySQL (:3306)
```

## Estructura Docker (monorepo)

```
proyecto-semestral/
├── docker-compose.yml              ← UNICO compose local (stack completo)
├── front_despacho/Dockerfile       ← solo Dockerfile
├── back-Ventas_.../Dockerfile
├── back-Despachos_.../Dockerfile
└── deploy/
    ├── docker-compose.ec2-backend.yml   ← solo para AWS/CI-CD
    └── docker-compose.ec2-frontend.yml
```

| Requisito | Archivo |
|---|---|
| Dockerfile multi-stage + minimo privilegio | `front_despacho/Dockerfile`, backends `Dockerfile` |
| docker-compose stack completo | `docker-compose.yml` (raiz) |
| Persistencia (named volumes) | `mysql_data`, `ventas_logs`, `despacho_logs` |
| CI/CD GitHub Actions | `.github/workflows/*.yml` |
| Deploy EC2 | `deploy/docker-compose.ec2-*.yml` + scripts |

## Prueba local

```powershell
Copy-Item .env.example .env
docker compose up --build -d
# Frontend: http://localhost:3000
# API proxy: http://localhost:3000/api/v1/ventas
```

## GitHub Secrets requeridos

`DOCKER_USERNAME`, `DOCKER_PASSWORD`, `EC2_FRONTEND_HOST`, `EC2_BACKEND_HOST`, `EC2_USER`, `EC2_SSH_KEY`, `BACKEND_VENTAS_HOST`, `BACKEND_DESPACHO_HOST`, `DB_ENDPOINT`, `DB_PORT`, `DB_NAME`, `DB_USERNAME`, `DB_PASSWORD`

## Push a deploy

```bash
git checkout -b deploy
git add .
git commit -m "EP2: docker + CI/CD + deploy EC2"
git push origin deploy
```

## Defensa tecnica - puntos clave

- **Multi-stage build**: reduce tamano de imagen (build vs runtime)
- **Minimo privilegio**: backends corren como usuario `spring`, no root
- **Named volumes**: persistencia MySQL entre reinicios
- **Nginx proxy**: frontend llama rutas relativas; Nginx enruta al backend privado
- **CI/CD**: push deploy → test → build → push Docker Hub → SSH EC2 → docker compose up
