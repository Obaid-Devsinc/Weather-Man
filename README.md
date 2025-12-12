## _Weather Man_

_Weather Man is a Ruby console application that processes weather data files and generates insightful reports for a given year or month._

## _Functionalities_

#### 1. _Yearly Weather Report_
_Display the highest temperature and day, lowest temperature and day, and most humid day and humidity for a given year. Analyzes all monthly files for the specified year to find and report annual extremes. Requires 4-digit year format (e.g., 2002)._

_**Usage:**_
```bash
ruby main.rb -e 2002 /path/to/filesFolder
```

_**Example Output:**_
```text
Highest: 45C on June 23
Lowest: 01C on December 22
Humid: 95% on August 14
```
#### 2. _Monthly Averages Report_

_Display the average highest temperature, average lowest temperature, and average humidity for a specific month. The -a flag calculates daily averages from a single month's data file. Requires date in YYYY/MM format._
_**Usage:**_
```bash
ruby main.rb -a 2005/6 /path/to/files
```

_**Example Output:**_
```text
Highest Average: 39C
Lowest Average: 18C
Average Humidity: 71%
```
#### 3. _Monthly Visual Temperature Chart_

_Draw two horizontal bar charts showing highest and lowest  temperatures for each day of a month. The -c flag generates a visual temperature chart for quick pattern recognition. Requires date in YYYY/MM format._

- _Highest temperature in **red**_
- _Lowest temperature in **blue**_

_**Usage:**_
```bash
ruby main.rb -c 2011/03 /path/to/files
```

_**Example Output:**_
```text
March 2011
01 ++++++++++++++++++++++++ 25C
01 +++++++++++ 11C
02 +++++++++++++++++++++ 22C
02 ++++++++ 08C
```
