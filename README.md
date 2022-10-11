# Cloud Native Deployment Strategies

| :warning: WARNING          |
|:---------------------------|
| Work in progress           |

## Introduction
 
One important topic in the `Cloud Native` application development paradigm is the `Microservice Architecture`. We are not dealing with one monolithic application any more. We have several applications that have dependencies on each other and also have other external dependencies like brokers or databases.
 
Each applications has its own life cycle, so we should be able to execute independent deployment. It is an importanta note that all the applications and dependencies will not change their version at the same time.
 
Another important topic in the `Cloud Native` paradigm is the `Continuous Delivery`. If we are going to have several applications doing deployments independently, with independent versions, we need to have a way to automate it. We propose the use of **Helm**, **Openshift GitOps**, and of course **Red Hat Openshift** to help us.
 
**In this repository we are going to test and compare different continuous deployment strategies with `Cloud Native` applications. We will see real examples of how to install, deploy and manage the life cycle of `Cloud Native` applications using those strategies.**
 
## Continuous Deployment Strategies

We are prosing the use of two different deployment strategies blue/green deploiyments and canary deployments, each implemented with two or three different approaches, This will leave us with 5 different combinations to compare.

### Blue / Green deployments

In [blue/green deployments](https://www.redhat.com/en/topics/devops/what-is-blue-green-deployment) we have two concurrent deployments of the same application with two differente versions, and the traffic gradually migrates from the current (blue) version to the new (green) version.

The performance or impact of the new version is monitored and if everything goes according to plan, the percentage of traffic that is directed towards the green version becomes 100%.

The blue version remains active and provides a easy rollback path in case the green version has some issues.


### Canary deployments

In [canary deployments](https://developers.redhat.com/blog/2022/10/07/coming-terms-canary-deployment) we have several concurrent versions of the same application with slight differences, and we direct a portion of our client traffic to each version and observe the difference in it performance and usability.

Canary deployments allows us to test multiple versions of our application in production at the same time, and see the impact of each version.

Those are the different `Cloud Native` deployment strategies that we have developed, you can click on each one and test it.

- [**Blue/Green** using **Openshift Pipelines**](/blue-green-pipeline)
- [**Blue/Green** using **Argo Rollouts**](/blue-green-argo-rollouts)
- [**Canary** using **Argo Rollouts**](/canary-argo-rollouts)
- [**Canary** using **Openshift Service Mesh** (Work in progress)](/canary-service-mesh)
- [**Canary** using **Argo Rollouts** and **Openshift Service Mesh** (Work in progress)](/canary-rollouts-service-mesh)



Those are the advantages and disadvantages of all of those deployment strategies:

Advantages:

- Minimize downtime
- Rapid way to rollback
 
Disadvantages:

- Backward compatibility

## Deployment Strategies comparison

This is the comparison between the different strategy:

| Name                                  | Advantage | Disadvantage |
| ------------------------------------- | --------- | ------------ |
| Blue/Green Openshift Pipelines        |           |              |
| Blue/Green Argo Rollouts              |           |              |
| Canary Argo Rollouts                  |           |              |
| Canary Service Mesh                   |           |              |
| Canary Argo Rollouts and Service Mesh |           |              |



