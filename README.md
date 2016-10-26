# docker-xetex

This docker image provides a XeTeX environment with additional LaTeX packages.

This image doesn't claim to be a entire XeTeX environment with all packages available.
So if you're missing some packages, please consider adapting the Dockerfile.

## How to use this image

This image provides `VOLUME /sources` for compiling a mounted LaTeX project.

### Compiling a LaTeX file

```
$ docker run --rm -v latex-project-folder:/sources xetex xelatex /sources/main-file.tex
```

