### Guía de Compilación, Ejecución y Despliegue con Docker
## 1. Creación del compilado
Ejecuta el comando:

  `.\mvnw clean install`

Si el comando no funciona, asegúrate de que el archivo pom.xml incluye el siguiente plugin de Maven. Esto asegura que se genere un archivo JAR con la clase principal configurada en el manifiesto:

  ```
  <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-jar-plugin</artifactId>
      <version>3.1.0</version>
      <configuration>
          <archive>
              <manifest>
                  <mainClass>com.lilblue.demo.DemoApplication</mainClass>
              </manifest>
          </archive>
      </configuration>
  </plugin>
  ```

Una vez modificado, ejecuta el siguiente comando para crear el compilado:

  `.\mvnw package spring-boot:repackage`

## 2. Ejecución del compilado
Para ejecutar el archivo generado, utiliza el siguiente comando (sustituyendo el nombre del archivo JAR si es diferente):

  `java -jar ./target/demo-0.0.1-SNAPSHOT.jar`

## 3. Creación de la imagen Docker
Construye la imagen Docker utilizando el archivo Dockerfile existente en el proyecto:

  `docker image build . -f Dockerfile --tag api-test/web`

## 4. Ejecución de la imagen Docker
Inicia un contenedor basado en la imagen creada:

  `docker run -d -p 8080:8080 --name my-api api-test/web`

## 5. Etiquetado de la imagen
Etiqueta la imagen para su publicación en un repositorio (sustituye sebasnavarro y myapp por tus valores):

  `docker tag api-test/web sebasnavarro/myapp:v1`

## 6. Publicación de la imagen
Publica la imagen en un registro remoto, como Docker Hub:

  `docker push sebasnavarro/myapp:v1`

***
## Descargar imagen desde un servidor de docker

## 1. Iniciamos sesion en docker

  `docker login`

## 2. Tirar la imagen desde Docker Hub

  `docker pull sebasnavarro/myapp:v1 `

## 3. Ejecutar el contenedor en el servidor

  `docker run -d -p 8080:8080 --name my-api sebasnavarro/myapp:v1 `

## 4. Verificamos si el contenedor esta corriendo

  `docker ps`

***
## Datos Adicionales

Eliminar contenedores existentes
Si deseas crear un nuevo contenedor con el mismo nombre, primero debes detener y eliminar el contenedor existente:

  `docker stop my-api`
  `docker rm my-api`

## 1. Asignar puertos al contenedor

Si el servicio no tiene un puerto asignado en el archivo Dockerfile o necesitas mapearlo manualmente, utiliza la opción -p para asignar el puerto. Por ejemplo:
bash

  `docker run -d -p 8080:8080 --name my-api api-test/web`

Esto mapea el puerto 8080 del host al puerto 8080 del contenedor.

## 2. Verificar contenedores en ejecución

Para verificar qué contenedores están activos:

`docker ps`



Para ver todos los contenedores (activos e inactivos):

`docker ps -a`



***
Dockerizar FRONT:


## 1. Hacemos un build al proyecto.

  `ng build`
## 2. Creación de la imagen Docker
Construye la imagen Docker utilizando el archivo Dockerfile existente en el proyecto:

  `docker image build . -f Dockerfile --tag colegiofront`

## 3. Ejecución de la imagen Docker
Inicia un contenedor basado en la imagen creada:

  `docker run -d -p 3000:80 colegiofront`

## 4. Etiquetado de la imagen
Etiqueta la imagen para su publicación en un repositorio (sustituye sebasnavarro y myapp por tus valores):
  `docker tag colegiofront sebasnavarro/colegiofront:v1`

## 5. Publicación de la imagen
Publica la imagen en un registro remoto, como Docker Hub:

  `docker push sebasnavarro/colegiofront:v1`

  ***
## Descargar imagen desde un servidor de docker

## 1. Iniciamos sesion en docker

  `docker login`

## 2. Tirar la imagen desde Docker Hub

  `docker pull sebasnavarro/colegiofront:v1 `

## 3. Ejecutar el contenedor en el servidor

  `docker run -d -p 3000:80 --name colegiofront sebasnavarro/myapp:v1 `

## 4. Verificamos si el contenedor esta corriendo

  `docker ps -a`

  ***
## Datos Adicionales

Eliminar contenedores existentes
Si deseas crear un nuevo contenedor con el mismo nombre, primero debes detener y eliminar el contenedor existente:

  `docker stop colegiofront`
  `docker rm colegiofront`

## 1. Asignar puertos al contenedor

Si el servicio no tiene un puerto asignado en el archivo Dockerfile o necesitas mapearlo manualmente, utiliza la opción -p para asignar el puerto. Por ejemplo:
bash

  `docker run -d -p 3000:80 colegiofront`

Esto mapea el puerto 8080 del host al puerto 8080 del contenedor.

## 2. Verificar contenedores en ejecución

Para verificar qué contenedores están activos:

`docker ps`

***
Configurar VPS con SSL y dominio:


## 1. Red y carpeta de certificados:

`docker network create web || true`
`mkdir -p ~/traefik/letsencrypt`
`touch ~/traefik/letsencrypt/acme.json`
`chmod 600 ~/traefik/letsencrypt/acme.json`

## 2. Traefik (reverse-proxy + SSL) (El correo (--certificatesresolvers.le.acme.email=TU-CORREO@DOMINIO.COM) no tiene que ser del mismo dominio. Let’s Encrypt solo lo usa para enviarte avisos si algo falla con la renovación del certificado.

  ```
docker run -d \
  --name traefik \
  --network web \
  -p 80:80 -p 443:443 \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v ~/traefik/letsencrypt:/letsencrypt \
  traefik:v2.11 \
  --providers.docker=true \
  --providers.docker.exposedbydefault=false \
  --entrypoints.web.address=:80 \
  --entrypoints.websecure.address=:443 \
  --entrypoints.web.http.redirections.entryPoint.to=websecure \
  --entrypoints.web.http.redirections.entryPoint.scheme=https \
  --certificatesresolvers.le.acme.httpchallenge=true \
  --certificatesresolvers.le.acme.httpchallenge.entrypoint=web \
  --certificatesresolvers.le.acme.email=TU-CORREO@DOMINIO.COM \
  --certificatesresolvers.le.acme.storage=/letsencrypt/acme.json

  ```
## 3. Detener contenedores actuales
`docker rm -f colegiofront 2>/dev/null || true`
`docker rm -f api-mariareyna 2>/dev/null || true`

## 4. Frontend (Angular con Nginx dentro)

`docker rm -f colegiofront 2>/dev/null || true`

```
docker run -d \
  --name colegiofront \
  --network web \
  --label "traefik.enable=true" \
  --label 'traefik.http.routers.front.rule=Host(`colegiomariareyna.com`) || Host(`www.colegiomariareyna.com`)' \
  --label "traefik.http.routers.front.entrypoints=websecure" \
  --label "traefik.http.routers.front.tls.certresolver=le" \
  --label "traefik.http.services.front.loadbalancer.server.port=80" \
  sebasnavarro/colegiofront
```
## 5. Backend (Angular con Nginx dentro)
`docker rm -f api-mariareyna 2>/dev/null || true`

```
docker run -d \
  --name api-mariareyna \
  --network web \
  --label "traefik.enable=true" \
  --label 'traefik.http.routers.api.rule=Host("api.colegiomariareyna.com")' \
  --label "traefik.http.routers.api.entrypoints=websecure" \
  --label "traefik.http.routers.api.tls.certresolver=le" \
  --label "traefik.http.services.api.loadbalancer.server.port=8080" \
  sebasnavarro/mariareyna:v5
```
