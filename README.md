# README

Sets up the services to run Alga.

Starts [IQFeed][1], followed by [IB Gateway][2], and then finally
[Algatrader][3].

[1]: https://github.com/okinta/alga-infra#iqfeed-server
[2]: https://github.com/okinta/stack-ibgateway
[3]: https://github.com/okinta/stack-algatrader

## Development

### Build

    docker build -t okinta/algasetup .

### Running

To run locally, first connect to Vault:

    ssh -N -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -L 7020:127.0.0.1:7020 <VAULT HOST>

Then run the container:

    docker run --add-host "vault.in.okinta.ge:$(docker run alpine getent hosts host.docker.internal | cut -d' ' -f1)" okinta/algasetup
