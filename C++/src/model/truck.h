#ifndef _MODEL_TRUCK_HPP_
#define _MODEL_TRUCK_HPP_

#include "vehicle.h"

class Truck : public Vehicle {
 public:
  Truck(std::string _make, std::string _model,
        int _year, int _bedLength);
  virtual ~Truck();

  int bedLength() const;
  void bedLengthIs(int _bedLength);

 private:
  int bedLength_;
};

#endif // _MODEL_TRUCK_HPP_
