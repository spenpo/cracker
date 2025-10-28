INSERT INTO public.feature_flag ("name",description,is_enabled,required_role) VALUES
	 ('premiumDashboardSwitch','a switch that changes state from basic to premium dashboard. brings up upgrade popup for basic members','0',NULL),
	 ('adminDashboardMenuItem','option in user menu that navigates to admin dashboard','1',3);
