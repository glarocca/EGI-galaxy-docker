# EGI-galaxy-docker
Used the generic <a href="https://galaxyproject.org/admin/config/apache-external-user-auth/">Apache External User Authentication </a>mechanism and the docker-compose.xml file to enable federated access to a <a href="https://hub.docker.com/r/bgruening/galaxy-stable">Galaxy Docker installation</a>.

In this case, Apache2 + Shibboleth module are configured to pass the federated user id to Galaxy through the $REMOTE_USER variable.
