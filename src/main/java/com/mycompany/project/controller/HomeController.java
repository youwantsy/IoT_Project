package com.mycompany.project.controller;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
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
	public String iotProject(){
		LOGGER.info("실행");
		return "home/iotProject";
	}
	
	@RequestMapping("/distanceView.do")
	public String distanceView(){
		LOGGER.info("실행");
		return "home/distanceView";
	}
	@RequestMapping("/ultraGraph.do")
	public String ultra() {
		return "home/ultraGraph"; 
	}
	@RequestMapping("/temperatureGraph.do")
	public String temperature() {
		return "home/temperatureGraph"; 
	}
	@RequestMapping("/gasGraph.do")
	public String gas() {
		return "home/gasGraph"; 
	}
}