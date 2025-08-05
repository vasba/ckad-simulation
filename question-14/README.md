# Question 14 | Secret, Secret-Volume, Secret-Env

## Task
You need to make changes on an existing Pod in Namespace `moon` called `secret-handler`. Create a new Secret `secret1` which contains `user=test` and `pass=pwd`. The Secret's content should be available in Pod `secret-handler` as environment variables `SECRET1_USER` and `SECRET1_PASS`. The yaml for Pod `secret-handler` is available at `$HOME/ckad-simulation/14/secret-handler.yaml`.

There is existing yaml for another Secret at `$HOME/ckad-simulation/14/secret2.yaml`, create this Secret and mount it inside the same Pod at `/tmp/secret2`. Your changes should be saved under `$HOME/ckad-simulation/14/secret-handler-new.yaml`. Both Secrets should only be available in Namespace `moon`.

