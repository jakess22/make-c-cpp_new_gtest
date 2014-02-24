#ifndef _MODEL_VEHICLE_HPP_
#define _MODEL_VEHICLE_HPP_

#include <string>

class Vehicle {
 public:
  Vehicle(std::string _make, std::string _model, int _year);
  virtual ~Vehicle();

  std::string make() const;
  void makeIs(std::string _make);
  std::string model() const;
  void modelIs(std::string _model);
  int year() const;
  void yearIs(int _year);

 private:
  std::string make_;
  std::string model_;
  int year_;
};

#endif // _MODEL_VEHICLE_HPP_
