/datum/outfit
	var/name = "Naked"

	var/uniform = null
	var/suit = null
	var/back = null
	var/belt = null
	var/gloves = null
	var/shoes = null
	var/head = null
	var/mask = null
	var/neck = null
	var/ears = null
	var/glasses = null
	var/id = null
	var/l_pocket = null
	var/r_pocket = null
	var/suit_store = null
	var/r_hand = null
	var/l_hand = null
	var/weapon = null
	var/internals_slot = null //ID of slot containing a gas tank
	var/list/backpack_contents = list() // In the list(path=count,otherpath=count) format
	var/list/belt_contents = list()

/datum/outfit/proc/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE, /datum/outfit/additional)
	//to be overriden for customization depending on client prefs,species etc
	return

/datum/outfit/proc/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	//to be overriden for toggling internals, id binding, access etc
	return

/datum/outfit/proc/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	pre_equip(H, visualsOnly)

	//Start with uniform,suit,backpack for additional slots
	if(uniform)
		H.equip_to_slot_or_del(PoolOrNew(uniform, H),slot_w_uniform)
	CHECK_TICK
	if(suit)
		H.equip_to_slot_or_del(PoolOrNew(suit,H),slot_wear_suit)
	CHECK_TICK
	if(back)
		H.equip_to_slot_or_del(PoolOrNew(back,H),slot_back)
	CHECK_TICK
	if(belt)
		H.equip_to_slot_or_del(PoolOrNew(belt,H),slot_belt)
	CHECK_TICK
	if(gloves)
		H.equip_to_slot_or_del(PoolOrNew(gloves,H),slot_gloves)
	CHECK_TICK
	if(shoes)
		H.equip_to_slot_or_del(PoolOrNew(shoes,H),slot_shoes)
	CHECK_TICK
	if(head)
		H.equip_to_slot_or_del(PoolOrNew(head,H),slot_head)
	CHECK_TICK
	if(mask)
		H.equip_to_slot_or_del(PoolOrNew(mask,H),slot_wear_mask)
	CHECK_TICK
	if(neck)
		H.equip_to_slot_or_del(PoolOrNew(neck,H),slot_neck)
	CHECK_TICK
	if(ears)
		H.equip_to_slot_or_del(PoolOrNew(ears,H),slot_ears)
	CHECK_TICK
	if(glasses)
		H.equip_to_slot_or_del(PoolOrNew(glasses,H),slot_glasses)
	CHECK_TICK
	if(id)
		H.equip_to_slot_or_del(PoolOrNew(id,H),slot_wear_id)
	CHECK_TICK
	if(suit_store)
		H.equip_to_slot_or_del(PoolOrNew(suit_store,H),slot_s_store)
	CHECK_TICK

	if(weapon)
		H.put_in_r_hand(PoolOrNew(weapon,H))
		H.quick_equip()
	CHECK_TICK

	if(l_hand)
		H.put_in_l_hand(PoolOrNew(l_hand,H))
	CHECK_TICK
	if(r_hand)
		H.put_in_r_hand(PoolOrNew(r_hand,H))
	CHECK_TICK

	if(!visualsOnly) // Items in pockets or backpack don't show up on mob's icon.
		if(l_pocket)
			H.equip_to_slot_or_del(PoolOrNew(l_pocket,H),slot_l_store)
			CHECK_TICK
		if(r_pocket)
			H.equip_to_slot_or_del(PoolOrNew(r_pocket,H),slot_r_store)
			CHECK_TICK

		for(var/path in backpack_contents)
			var/number = backpack_contents[path]
			for(var/i=0,i<number,i++)
				H.equip_to_slot_or_del(PoolOrNew(path,H),slot_in_backpack)
				CHECK_TICK
		for(var/path in belt_contents)
			var/number = belt_contents[path]
			for(var/i=0,i<number,i++)
				H.belt:handle_item_insertion(PoolOrNew(path,H), 1, H)
				CHECK_TICK

	if(!H.head && istype(H.wear_suit, /obj/item/clothing/suit/space/hardsuit))
		var/obj/item/clothing/suit/space/hardsuit/HS = H.wear_suit
		HS.ToggleHelmet()

	post_equip(H, visualsOnly)

	if(!visualsOnly)
		apply_fingerprints(H)
		if(internals_slot)
			H.internal = H.get_item_by_slot(internals_slot)
			H.update_action_buttons_icon()

	H.update_body()
	return 1

/datum/outfit/proc/apply_fingerprints(mob/living/carbon/human/H)
	if(!istype(H))
		return
	if(H.back)
		H.back.add_fingerprint(H,1)	//The 1 sets a flag to ignore gloves
		for(var/obj/item/I in H.back.contents)
			I.add_fingerprint(H,1)
	if(H.wear_id)
		H.wear_id.add_fingerprint(H,1)
	if(H.w_uniform)
		H.w_uniform.add_fingerprint(H,1)
	if(H.wear_suit)
		H.wear_suit.add_fingerprint(H,1)
	if(H.wear_mask)
		H.wear_mask.add_fingerprint(H,1)
	if(H.wear_neck)
		H.wear_neck.add_fingerprint(H,1)
	if(H.head)
		H.head.add_fingerprint(H,1)
	if(H.shoes)
		H.shoes.add_fingerprint(H,1)
	if(H.gloves)
		H.gloves.add_fingerprint(H,1)
	if(H.ears)
		H.ears.add_fingerprint(H,1)
	if(H.glasses)
		H.glasses.add_fingerprint(H,1)
	if(H.belt)
		H.belt.add_fingerprint(H,1)
		for(var/obj/item/I in H.belt.contents)
			I.add_fingerprint(H,1)
	if(H.s_store)
		H.s_store.add_fingerprint(H,1)
	if(H.l_store)
		H.l_store.add_fingerprint(H,1)
	if(H.r_store)
		H.r_store.add_fingerprint(H,1)
	for(var/V in H.held_items)
		var/obj/item/I = V
		if(I)
			I.add_fingerprint(H,1)
	return 1
