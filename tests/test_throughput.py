import unittest
from projects.networking.throughput import megabits_per_second


class ThroughputTests(unittest.TestCase):
    def test_megabits_per_second(self):
        self.assertAlmostEqual(megabits_per_second(1_000_000, 1), 8.0)

    def test_rejects_invalid_values(self):
        with self.assertRaises(ValueError):
            megabits_per_second(-1, 1)
        with self.assertRaises(ValueError):
            megabits_per_second(10, 0)


if __name__ == "__main__":
    unittest.main()
