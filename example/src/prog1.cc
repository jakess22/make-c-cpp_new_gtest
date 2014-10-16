/*
 * Copyright (c) 2014, Joe Example
 */
#include <cassert>
#include <cstdint>
#include <fstream>  //NOLINT
#include <sstream>
#include <vector>

#include "util/LinkedList.h"

#include "model/Vehicle.h"
#include "model/Truck.h"
#include "model/Car.h"

#include "json/json.h"
#include "zlib/zlib.h"

int main(int argc, char** argv) {
  for (int i = 0; i < argc; i++) {
    printf("Arg[%i]: %s\n", i, argv[i]);
  }

  if (argc != 2) {
    fprintf(stderr, "You must specify a settings file\n");
    return -1;
  }

  char* configFile = argv[1];
  Json::Value settings;

  std::ifstream is(configFile, std::ifstream::binary);
  if (!is) {
    fprintf(stderr, "Settings error: could not open file '%s'\n", configFile);
    return -1;
  }

  Json::Reader reader;
  bool success = reader.parse(is, settings, true);
  is.close();

  if (!success) {
    fprintf(stderr, "Settings error: failed to parse JSON file '%s'\n",
            configFile);
    fprintf(stderr, "%s\n", reader.getFormattedErrorMessages().c_str());
    return -1;
  }

  printf("################# Settings Start #################\n");
  Json::StyledWriter writer;
  printf("%s\n", writer.write(settings).c_str());
  printf("################# Settings End ###################\n");

  std::vector<Vehicle> trucks;
  std::vector<Vehicle> cars;
  LinkedList<Vehicle> allVehicles;

  Json::Value vehicles = settings["Vehicle"];
  for (unsigned int i = 0; i < vehicles.size(); i++) {
    printf("adding vehicle\n");
    Json::Value vehicle = vehicles[i];
    std::string make = vehicle["make"].asString();
    std::string model = vehicle["model"].asString();
    int year = vehicle["year"].asInt();
    if (vehicle["type"].asString() == "Truck") {
      int bedLength = vehicle["bedLength"].asInt();
      Truck truck(make, model, year, bedLength);
      trucks.push_back(truck);
      allVehicles.push(&truck);
    } else if (vehicle["type"].asString() == "Car") {
      int mpg = vehicle["mpg"].asInt();
      Car car(make, model, year, mpg);
      cars.push_back(car);
      allVehicles.push(&car);
    } else {
      fprintf(stderr, "unknown vehicle type: '%s'\n",
              vehicle["type"].asCString());
      return -1;
    }
  }

  printf("you initialized %lu vehicles\n", allVehicles.size());

  std::stringstream ss;
  for (auto it = cars.begin(); it != cars.end(); ++it) {
    Vehicle car = (*it);
    printf("Car: %s %s %u\n", car.make().c_str(), car.model().c_str(),
           car.year());
  }
  for (auto it = trucks.begin(); it != trucks.end(); ++it) {
    Vehicle truck = (*it);
    printf("Truck: %s %s %u\n", truck.make().c_str(), truck.model().c_str(),
           truck.year());
  }
  const std::string str = ss.str();
  const char* cstr = str.c_str();
  int64_t slen = str.size();

  printf("%s", str.c_str());;

  gzFile fout = gzopen("vehicles.gz", "wb");
  assert(gzwrite(fout, cstr, slen) == slen);
  gzclose(fout);

  return 0;
}
