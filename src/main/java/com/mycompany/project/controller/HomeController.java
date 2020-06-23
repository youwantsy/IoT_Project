package com.mycompany.project.controller;

import java.util.Calendar;
import java.util.TimeZone;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/home") 
public class HomeController 
{
	private static final Logger LOGGER = LoggerFactory.getLogger(HomeController.class);

	@RequestMapping("/main.do") 
	public String main(String Ledvalue) throws Exception
	{
		LOGGER.info("실행");
		return "home/main";
	}
	
	@RequestMapping("/iotProject.do")
	public String iotProject()
	{
		LOGGER.info("실행");
		return "home/iotProject";
	}
	
	@RequestMapping("/distanceView.do")
	public String distanceView()
	{
		LOGGER.info("실행");
		return "home/distanceView";
	}
	@RequestMapping("/ultraGraph.do")
	public String exam04() {
		
		return "home/ultraGraph"; 
	}

}