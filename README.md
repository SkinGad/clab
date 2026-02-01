# Labs repo

## How to start using

1. Install Ubuntu

2. Clone the repository

3. To access sudo permission without running the command:
```shell
make sudo-nopass
```

4. Install the Clab by running the command:
```shell
make install-clab
```

5. Make sure the user is a member of the docker group (using the `groups` command) and can run the `docker ps` command.
If this doesn't work, restart the terminal or VS Code

6. It is necessary to collect the required device images using the command:
```shell
make build
```

## Further use

In the future, you will need to run this command regularly before starting experiments:
```shell
make update
```
