/obj/structure/mopbucket
	desc = "Fill it with water, but don't forget a mop!"
	name = "mop bucket"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mopbucket"
	density = 1
	var/lockedby=""
	pressure_resistance = 5
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	var/amount_per_transfer_from_this = 5 //shit I dunno, adding this so syringes stop runtime erroring. --NeoFite

/obj/structure/mopbucket/New()
	var/datum/reagents/R = new/datum/reagents(100)
	reagents = R
	R.my_atom = src


/obj/structure/mopbucket/examine()
	set src in usr
	usr << "\icon[src] [name] contains [reagents.total_volume] units of water left!"
	if(anchored)
		usr << "\icon[src] \The [name]'s wheels are locked!"
	..()

/obj/structure/mopbucket/attack_hand(mob/user as mob)
	..()
	anchored=!anchored
	if(anchored)
		usr << "\icon[src] You lock the \the [name]'s wheels!"
		lockedby += "\[[time_stamp()]\][usr](ckey:[usr.ckey]) - locked<br />"
	else
		usr << "\icon[src] You unlock the \the [name]'s wheels!"
		lockedby += "\[[time_stamp()]\][usr](ckey:[usr.ckey]) - unlocked<br />"

/obj/structure/mopbucket/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/mop))
		if (src.reagents.total_volume >= 2)
			src.reagents.trans_to(W, 2)
			user << "\blue You wet the mop"
			playsound(src.loc, 'sound/effects/slosh.ogg', 25, 1)
		if (src.reagents.total_volume < 1)
			user << "\blue Out of water!"
	return

/obj/structure/mopbucket/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(50))
				del(src)
				return
		if(3.0)
			if (prob(5))
				del(src)
				return
