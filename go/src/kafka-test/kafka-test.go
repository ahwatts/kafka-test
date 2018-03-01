package main

import (
	"fmt"
	"gopkg.in/Shopify/sarama.v1"
	"strconv"
	"sync"
)

func main() {
	config := sarama.NewConfig()
	config.ClientID = "kafka-test-go-consumer"

	client, err := sarama.NewClient(
		[]string{"kafka1:9092", "kafka2:9092", "kafka3:9092"},
		config)
	if err != nil {
		fmt.Println("Error creating client:", err)
		return
	}

	partitions, err := client.Partitions("random_numbers")
	if err != nil {
		fmt.Println("Error getting partitions:", err)
		return
	}

	consumer, err := sarama.NewConsumerFromClient(client)
	if err != nil {
		fmt.Println("Error creating consumer:", err)
		return
	}

	offsetManager, err := sarama.NewOffsetManagerFromClient("go-consumer", client)
	if err != nil {
		fmt.Println("Error creating offset manager:", err)
		return
	}

	var waitGroup sync.WaitGroup

	for _, partition := range partitions {
		partitionOffsetManager, err := offsetManager.ManagePartition("random_numbers", partition)
		if err != nil {
			fmt.Println("Error creating partition offset manager:", err)
			return
		}

		offset, _ := partitionOffsetManager.NextOffset()
		fmt.Println("Partition", partition, "at initial offset", offset)

		partitionConsumer, err := consumer.ConsumePartition("random_numbers", partition, offset)
		if err != nil {
			fmt.Println("Error creating partition consumer:", err)
			return
		}

		waitGroup.Add(1)
		go func(consumer sarama.PartitionConsumer, manager sarama.PartitionOffsetManager, thisPartition int32) {
			defer waitGroup.Done()
			for message := range consumer.Messages() {
				ivalue, _ := strconv.Atoi(string(message.Value))
				if message.Offset != int64(ivalue) {
					fmt.Println("Message value mismatch:", message)
				}
				manager.MarkOffset(message.Offset, "")
				if message.Offset % 10 == 0 {
					fmt.Println("Partition", thisPartition, "at offset", message.Offset)
				}
			}
		}(partitionConsumer, partitionOffsetManager, partition)
	}

	waitGroup.Wait()
}
