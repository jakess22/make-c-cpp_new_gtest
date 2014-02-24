#ifndef _MODEL_CAR_HPP_
#define _MODEL_CAR_HPP_

#include "vehicle.h"

class Car : public Vehicle {
 public:
  Car(std::string _make, std::string _model,
        int _year, int _mpg);
  virtual ~Car();

  int mpg() const;
  void mpgIs(int _mpg);

 private:
  int mpg_;
};

#endif // _MODEL_CAR_HPP_
