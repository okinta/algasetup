# Algasetup Stack

An Okinta Stack that hosts sets up the services to run Alga.

## What is an Okinta Stack?

An Okinta stack is a deployable unit for Alga that runs within Okinta's
infrastructure. Stacks describe all necessary information to deploy a service.

For more information about Alga, refer to the [alga-infra repository][1].

## What is this Stack?

Starts [IQFeed][2], followed by [IB Gateway][3], and then finally
[Algatrader][4] each day before the trading session. Tears down the services at
the end of the trading session.

## Dependencies

This stack is dependent on the [agrix][5] to provision services.

## Development

### Build

    docker build -t okinta/stack-algasetup .

### Running

To run locally, first connect to Vault:

    ssh -N -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -L 7020:127.0.0.1:7020 <VAULT HOST>

Then run the container:

    docker run --add-host "vault.in.okinta.ge:$(docker run alpine getent hosts host.docker.internal | cut -d' ' -f1)" okinta/stack-algasetup

[1]: https://github.com/okinta/alga-infra
[2]: https://github.com/okinta/alga-infra#iqfeed-server
[3]: https://github.com/okinta/stack-ibgateway
[4]: https://github.com/okinta/stack-algatrader
[5]: https://github.com/okinta/agrix
