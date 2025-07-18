A set of docker containers to make a little build cluster for fun and learning.

All the images will be sub-domains of `dev.local`, e.g. `mail.dev.local` is the mail
server host name.


Setup
-----

First, edit setup.mk to set a few things.

To build everything just run `make` in the root of the repo.


Containers
----------

mail/           - Mail server using postfix which will accept mail for the cluster
                  as `@dev.local`. Setup account `dev@dev.local`. Read mail with 
                  `mutt` for now (implement pop3 or IMAP or something later).
fossil/         - Host for Fossil repos.


To Do
-----

gitlab/         - gitlab instance with postgres and redis
jenkins/        - jenkins server and build node (docker compose)
registry/       - docker registry for source images and build artifacts
template/       - template docker setup using a Makefile
webui/          - AI models in a container

