#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	if (argc < 4)
	{
		printf("Error, invalid arguments\n");
		exit(1);
	}

	int op, low, mult;
	float third, fourth;
	sscanf(argv[1], "%d", &op); 
	sscanf(argv[2], "%d", &low);
	sscanf(argv[3], "%d", &mult);

	switch (op)
	{
		case 0:
			printf("%f\n", (1 / (float) low) * mult);
			return 0;
		case 1:
			printf("%f\n", ( (1 -  ((float) low / 10)) * mult));
			return 0;
		case 2:
			if (argc < 6)
			{
				printf("Error, invalid arguments\n");
				exit(1);
			}
			sscanf(argv[4], "%f", &third);
			sscanf(argv[5], "%f", &fourth);
			printf("%f\n", (float) low + (float) mult + third + fourth);
			return 0;
		case 3:
			printf("%d\n", (int) low);
			return 0;
	}
}
