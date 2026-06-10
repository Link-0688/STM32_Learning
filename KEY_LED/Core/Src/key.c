#include "key.h"

uint8_t KEY_Scan(GPIO_TypeDef *GPIOx, uint16_t GPIO_Pin)
{
	if (HAL_GPIO_ReadPin(GPIOx, GPIO_Pin) == GPIO_PIN_RESET)//RESET:低电平 SET:高电平
    {
        HAL_Delay(20);
        if (HAL_GPIO_ReadPin(GPIOx, GPIO_Pin) == GPIO_PIN_RESET)
        {
					 while (HAL_GPIO_ReadPin(GPIOx, GPIO_Pin) == GPIO_PIN_RESET)
					 {}
            return 1;
        }
    }
    return 0;
}
