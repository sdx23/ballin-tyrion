acum <- c()

for(file in c(1,2,3,5,8,10,12)){
	v <- read.csv(paste("nn",file,".csv",sep=""), header=T)
	colnames(v) <- gsub("nnet.", "", colnames(v))
	cs <- colnames(v)[3:8]
	cum <- rep(0,6)
	for(i in 1:(dim(v)[1])) {
		i
		tc <- which.max(v[i,3:8])
		if(colnames(v)[tc+2] == v[i,2]){
			cum[v[i,2]] <- cum[v[i,2]] + 1
		}
	}
	nc <- c()
	for(c in cs) {
		tnc <- sum(v[,2] == c)
		nc <- cbind(nc, tnc)
	}
	
	cum <- cum/nc
	rownames(cum) <- file
	acum <- rbind(acum, cum)
}

colnames(acum) <- colnames(v)[3:8]
print(acum)
write.table(acum, file="acumnn.csv", quote=F)
