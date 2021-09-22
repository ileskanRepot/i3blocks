#include <stdio.h>
#include <stdlib.h>

int main(int argc, char const *argv[])
{
	char *COLOR;
	COLOR = (char *)malloc(6);
	COLOR = "red";
	char *LOGO = "\uf243";
	char *BATEMP = "\uf244";
	char *BATLOW = "\uf243";
	char *BATMID = "\uf242";
	char *BATHIGH = "\uf240";
	char *CHAR = "\uf0e7";

	char *energyNow;
	FILE *energyNowFd = fopen("/sys/class/power_supply/BAT0/energy_now", "rb");
	fseek(energyNowFd, 0, SEEK_END);
	long length = ftell(energyNowFd);
	fseek(energyNowFd, 0, SEEK_SET);
	energyNow = (char *)malloc(length);
	fread(energyNow, 1, length, energyNowFd);

	char *energyFull;
	FILE *energyFullFd = fopen("/sys/class/power_supply/BAT0/energy_full", "rb");
	fseek(energyFullFd, 0, SEEK_END);
	length = ftell(energyFullFd);
	fseek(energyFullFd, 0, SEEK_SET);
	energyFull = (char *)malloc(length);
	fread(energyFull, 1, length, energyFullFd);

	char *status;
	FILE *statusFd = fopen("/sys/class/power_supply/BAT0/status", "rb");
	fseek(statusFd, 0, SEEK_END);
	length = ftell(statusFd);
	fseek(statusFd, 0, SEEK_SET);
	status = (char *)malloc(length);
	fread(status, 1, length, statusFd);

	float energyNowF = atof(energyNow);
	float energyFullF = atof(energyFull);
	float batlvl = 100 * energyNowF / energyFullF;


	if (status[0] == 'C')
	{
		LOGO = CHAR;
		COLOR = "green";
	}
	else
	{
		if (batlvl > 95)
		{
			COLOR = "green";
			LOGO = BATHIGH;
		}
		else if (batlvl > 50)
		{
			COLOR = "black";
			LOGO = BATMID;
		}
		else if (batlvl > 15)
		{
			COLOR = "blue";
			LOGO = BATMID;
		}

		if (batlvl < 1)
		{
			system("systemctl hibernate");
		}
		else if (batlvl < 5)
		{
			char command[42];
			snprintf(command, 42, "notify-send -u critical \'BAT: %.2f", batlvl);
			command[34] = '%';
			command[35] = '\'';
			command[36] = '\0';
			system(command);
			LOGO = BATEMP;
		}
	}

	printf("<span background=\"%s\" foreground=\"#FFFFFF\">%s %.2f\%</span>\n", COLOR, LOGO, batlvl);
	//<span background="'$COLOR'" foreground="#FFFFFF">'$LOGO' '$BAT'%</span>
}
