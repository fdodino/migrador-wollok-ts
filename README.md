# migrador-wollok-ts

Script bash que permite migrar un proyecto de Wollok Xtext a wollok-ts

- Necesita como parámetros el repositorio y el nombre del proyecto

```bash
migrar-wollok-ts.sh wollok polimorfismoSueldoDePepe
```

- Toma en cuenta colisiones de archivos wtest y wpgm que se llamen igual que los wlk y los renombra
- Genera un tag "v1.0" en el proyecto de Wollok con la leyenda "Ultima versión Wollok Xtext"
- Le pone el CI de Github Actions
- Copia assets, directorios `img` o `im*` también
- Si el README tiene un badge de Travis lo reemplaza por el de Github Actions
- Sube al repositorio la nueva versión en la rama default

