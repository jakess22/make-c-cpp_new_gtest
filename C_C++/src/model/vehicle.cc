#include "vehicle.h"

Vehicle::Vehicle(std::string _make, std::string _model, int _year)
    : make_(_make), model_(_model), year_(_year) {}

Vehicle::~Vehicle() {}

std::string Vehicle::make() const {
  return make_;
}

void Vehicle::makeIs(std::string _make) {
  make_ = _make;
}

std::string Vehicle::model() const {
  return model_;
}

void Vehicle::modelIs(std::string _model) {
  model_ = _model;
}

int Vehicle::year() const {
  return year_;
}

void Vehicle::yearIs(int _year) {
  year_ = _year;
}
