#waf-data-platform
##Quick Start

To build your own dataplay3 container, run
```bash
make docker
```


and then start the dataplay3 in a container with
```bash
make run
```

open http://localhost:8000 to access dataplay3 ui.
Feature Overview

##plat provides following features:

    Dataset management
    Dataset query
    Data visualization
    A Simple dashboard
    Categorical data prediction
    Numerical data prediction
    Time serials data prediction


## run
to run dataplay3 in docker
```bash
docker run -p 8000:8000 naughtytao/dataplay3:0.1-dev
```

and the open your browser with following url
> [http://localhost:8000](http://localhost:8000)

note, the image size is **2.11GB**
