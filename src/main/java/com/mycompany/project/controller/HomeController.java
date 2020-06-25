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
	public String main(String Ledvalue) throws Exception{
		LOGGER.info("실행");
		return "home/main";
	}
	
	@RequestMapping("/ManualControl.do")
	public String manual(){
		LOGGER.info("실행");
		return "home/ManualControl";
	}
	@RequestMapping("/AutoControl.do")
	public String auto() {
		return "home/AutoControl"; 
	}
}