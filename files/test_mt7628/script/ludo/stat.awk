FILENAME == ARGV[1] { apn[$3]=1, bestlvl[$3]=-$4 }
FILENAME == ARGV[2] { noise[FNR]=$1 }
FILENAME == ARGV[3] { freq[FNR]=$1 }

END {	for(i=1;i<14;i++)
	{	left = 0;
		right = 0;
		left2 = 0;
		right2 = 0;
		
		if(i==1)
		{
			left = -1;
			left2 = -1;
			if(apn[i+1] > 0)
			   right = 1;
			if(apn[i+2] > 0)
			   right2 = 1;
		}

		if(i==2)
		{
			left2=-1;
			if(apn[i-1] > 0)
			   left=1;
			if(apn[i+1] > 0)
			   right = 1;
			if(apn[i+2] > 0)
			   right2 = 1;
		}

		if(i==12)
		{
			right2=-1;
			if(apn[i-1] > 0)
			   left=1;
			if(apn[i-2] > 0)
			   left2=1;
			if(apn[i+1] > 0)
			   right = 1;
		}

		if(i==13)
		{
			right = -1;
			right2 = -1;
			if(apn[i-1] > 0)
			   left = 1;
			if(apn[i-2] > 0)
			   left2 = 1;
		}

		if(i>2 && i<12)
		{
			if(apn[i-1] > 0)
			   left=1;
			if(apn[i-2] > 0)
			   left2=1;
			if(apn[i+1] > 0)
			   right = 1;
			if(apn[i+2] > 0)
			   right2 = 1;
		}
		
		if(apn[i]==0)
			print i " 0 " "100 " "100 " left " " right " " left2 " " right2 " " noise[i] " " freq[i];
		else		
			print i " " apn[i] " " bestlvl[i] " " bestlvl[i]/apn[i] " " left " " right " " left2 " " right2 " " noise[i] " " freq[i];
	}
}
