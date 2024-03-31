This is the home directory of this Docker container. 
Files inside `synced` (`$SYNCED`) are synced to the directory in which you ran this container.
Files elsewhere (e.g. inside `$SCRATCH`) are saved to a volume associated with this container, which you can access with `docker volume`.

DESI data releases are mounted at `desiroot` (`$DESI_ROOT`). 
Example code for processing the data can be found at `tutorials`.
