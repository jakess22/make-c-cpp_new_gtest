#include "gtest/gtest.h"

#include "truck.h"
#include "vehicle.h"

TEST(TruckTest, test) {
  Truck t("Ford", "F150", 1996, 5);
  ASSERT_TRUE(t.make() == "Ford");
  ASSERT_TRUE(t.model() == "F150");
  ASSERT_TRUE(t.year() == 1996);
  ASSERT_TRUE(t.bedLength() == 5);

  Vehicle* vehicle = dynamic_cast<Vehicle*>(&t);
  ASSERT_FALSE(vehicle == NULL);
}
