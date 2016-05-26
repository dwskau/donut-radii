To analyze data, pull it from the database using pull.sh

pull.sh
===

Step one. This script pulls data from Redis and stores it in results/data.json. Data.json contains all fields you saved when calling `experimentr.data()` and `experimentr.save()` on the front-end.

Note: experimentr does not enforce a data schema, so any individual entry in data.json may be missing values you want in your analysis. This is handled in the convert step.

    ./pull.sh