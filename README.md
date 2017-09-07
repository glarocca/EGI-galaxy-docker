# EGI-galaxy-docker
Used the generic <a href="https://galaxyproject.org/admin/config/apache-external-user-auth/">Apache External User Authentication</a> mechanism and the docker-compose.xml file to enable federated access to a <a href="https://hub.docker.com/r/bgruening/galaxy-stable">Galaxy Docker installation</a>.

* In this case, Apache2 + Shibboleth module are configured to pass the federated user id to Galaxy through the $REMOTE_USER variable.
* The server hostname where the Apache2 + Shibboleth module will be deployed is: https://galaxy-hub.fedcloud-tf.fedcloud.eu/

## Requirements

* The Apache2 + Shibboleth docker container used to proxy the Galaxy container has to be registered in the DNS.
* A trusted host certificates for the Apache2 + Shibboleth docker container is needed.
* The Apache2 + Shibboleth docker container has to be registered as Service Provider (SP) in the EGI AAI Check-In DEV instance.
** To do so, you have to send the SAML metadata of the new SP to nliam <at> grnet.gr.

## License
Licensed under the Apache License, Version 2.0 (the "License"); you may not use this project except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
