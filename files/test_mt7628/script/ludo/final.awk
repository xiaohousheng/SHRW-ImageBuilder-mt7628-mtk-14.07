{
	if($2==0)
	{
		apf[$1]=$1;
		fpoint=$1;	
	}
		ap[$1]=$2;
		lvl[$1]=$3;
		w[$1]=$4;
		l[$1]=$5;
		r[$1]=$6;
		l2[$1]=$7;
		r2[$1]=$8;
		n[$1]=$9;	
		f[$1]=$10;
}
END {
	if(apf[fpoint]=="")			#no free channels (FUUUCK) -> choose the one with min weight on the same ch
	{	weight=0;
		for(chocc in ap)	#at least one tap (l or r) free
		{
			if(weight<=w[chocc])
			{
				weight=w[chocc];
				bestch=chocc;				
			}				
		}
		print bestch " " f[bestch];
	}
	else				#at least one free channel (OK)
	{
		for (ch in apf) 
		{		
			#print "Channel free: "ch;
			if( (l[ch]==0 || l[ch]==-1) && (r[ch]==0 || r[ch]==-1))			#search for 1-2 tap free
				if( (l2[ch]==0 || l2[ch]==-1) && (r2[ch]==0 || r2[ch]==-1))
				{	
					#print "2 tap free: " ch;
					tap2[ch]=1;
					t2p=ch;				
				}
				else
				{
					if(((l2[ch]==0 || l2[ch]==-1) && (r1[ch]==0 || r1[ch]==-1)) || ((r2[ch]==0 || r2[ch]==-1) && (l1[ch]==0 || l1[ch]==-1)))
					{	
						#print "21 tap free: " ch;
						tap21[ch]=1;
						t21p=ch;				
					}
					else
					{	
						#print "1 tap free: " ch;
						tap1[ch]=1;
						t1p=ch;				
					}
				}	
		}
		
		if(tap2[t2p]==1)	#at least one with 2 tap free (UAONE) -> choose tbd
		{
		
				if(6 in tap2)
					bestch=6;
				else
				if(3 in tap2)
					bestch=3;
				else
				if(8 in tap2)
					bestch=8;
				else
				if(13 in tap2)
					bestch=13;
				else
				if(4 in tap2)
					bestch=4;
				else
				if(9 in tap2)
					bestch=9;
				else
				if(2 in tap2)
					bestch=2;
				else
				if(7 in tap2)
					bestch=7;
				else
				if(12 in tap2)
					bestch=12;
				else
				if(5 in tap2)
					bestch=5;
				else 
				if(10 in tap2)
					bestch= 10;
				else
				if(11 in tap2)
					bestch=11;
					else	
				if(1 in tap2)
					bestch=1;
				
				 print bestch " " f[bestch];


		}
		else
		{	weight=0;
			if(tap21[t21p]==1)	#at least one with 2 tap l/r (UAONE/2)
			{
				for(t2 in tap21)
				{					
					if(t2==1)
						if (weight<=w[t2+2])
						{	
							bestch=t2;
							weight=w[t2+2];						
						}
						if(t2==13)
							if(weight<=w[t2-2])
							{
								bestch=t2;
								weight=w[t2-2];						
							}
							if(t2!=13 && t2!=1)		
							{	if (l2[t2]==1)
								{
									if(weight<=w[t2-2])
									{
										bestch=t2;
										weight=w[t2-2];
									}						
								}
								else
									if(weight<=w[t2+2])
									{
										bestch=t2;
										weight=w[t2+2];
									}
							}	
				}
				print bestch " " f[bestch]; 
			}
			else			
			{	if(tap1[t1p]==1)	#at least one with 1 tap free (UAO) -> choose tbd
					for(i in tap1)
					{	
						#print "Tap1: " i;
					}
				else			#no one with 1 or 2 tap free (YAY) -> choose the one with min lvl/noise 	
				{
					weight=0;				
					for(ch in apf)	#at least one tap (l or r) free
					{
						if(l[ch]==1 && r[ch]==0)
							if(weight<w[ch-1])
							{
								bestch=ch;
								weight=w[ch-1];						
							}
						if(r[ch]==1 && l[ch]==0)
							if(weight<w[ch+1])
							{
								bestch=ch;
								weight=w[ch+1];						
							}				
					}
				
					if(weight==0) #both (r and l) occupied
						for(chnew in apf)	
						{
							if(chnew==1)
								if (weight<=w[chnew+1])
								{	
									bestch=chnew;
									weight=w[chnew+1];						
								}
							if(chnew==13)
								if(weight<=w[chnew-1])
								{
									bestch=chnew;
									weight=w[chnew-1];						
								}
							if(chnew!=13 && chnew!=1)		
								if (weight<=(w[chnew-1]+w[chnew+1])/2)
								{
									bestch=chnew;
									weight=(w[chnew-1]+w[chnew+1])/2;						
								}
						}

						print bestch " " f[bestch]; 
					}		
				}
			}
	}		
}
