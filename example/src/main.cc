#include "model/vehicle.h"
#include "model/truck.h"
#include "model/car.h"

#include "json/json.h"
#include "zlib/zlib.h"

#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <cassert>

int main(int argc, char** argv) {

  for (int i=0; i<argc; i++) {
    std::cout << "Arg[" << i << "]: " << argv[i] << std::endl;
  }

  if (argc != 2) {
    std::cerr << "You must specify a settings file" << std::endl;
    return -1;
  }

  char* configFile = argv[1];
  Json::Value settings;

  std::ifstream is(configFile, std::ifstream::binary);
  if (!is) {
    std::cerr << "Settings error: could not open file '" << configFile << "'" << std::endl;
    exit(-1);
  }

  Json::Reader reader;
  bool success = reader.parse(is, settings, true);
  is.close();

  if (!success) {
    std::cerr << "Settings error: failed to parse JSON file '" << configFile << "'" << std::endl
              << reader.getFormattedErrorMessages() << std::endl;
    return -1;
  }

  std::cout << "################# Settings Start #################" << std::endl;
  Json::StyledWriter writer;
  std::cout << writer.write(settings) << std::endl;
  std::cout << "################# Settings End ###################" << std::endl;

  std::vector<Vehicle> trucks;
  std::vector<Vehicle> cars;

  Json::Value vehicles = settings["Vehicle"];
  for (unsigned int i=0; i<vehicles.size(); i++) {
    std::cout << "adding vehicle" << std::endl;
    Json::Value vehicle = vehicles[i];
    std::string make = vehicle["make"].asString();
    std::string model = vehicle["model"].asString();
    int year = vehicle["year"].asInt();
    if (vehicle["type"].asString() == "Truck") {
      int bedLength = vehicle["bedLength"].asInt();
      Truck truck(make, model, year, bedLength);
      trucks.push_back(truck);
    }
    else if (vehicle["type"].asString() == "Car") {
      int mpg = vehicle["mpg"].asInt();
      Car car(make, model, year, mpg);
      cars.push_back(car);
    }
    else {
      std::cerr << "unknown vehicle type: '" << vehicle["type"].asString() <<
          "'" << std::endl;
    }
  }

  std::stringstream ss;
  for (auto it = cars.begin(); it != cars.end(); ++it) {
    Vehicle car = (*it);
    ss << "Car: " << car.make() << " " << car.model() << " " << car.year() <<
        " " << std::endl;
  }
  for (auto it = trucks.begin(); it != trucks.end(); ++it) {
    Vehicle truck = (*it);
    ss << "Truck: " << truck.make() << " " << truck.model() << " " <<
        truck.year() << " " << std::endl;
  }
  const std::string str = ss.str();
  const char* cstr = str.c_str();
  long int slen = str.size();

  std::cout << str;

  gzFile fout = gzopen("vehicles.gz", "wb");
  assert(gzwrite(fout, cstr, slen) == slen);
  gzclose(fout);

  return 0;
}
