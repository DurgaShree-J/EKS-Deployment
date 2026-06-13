import boto3

ec2 = boto3.client("ec2")

required_tags = [
    "Environment",
    "Project",
    "Owner",
    "ManagedBy"
]

instances = ec2.describe_instances()

for reservation in instances["Reservations"]:

    for instance in reservation["Instances"]:

        instance_id = instance["InstanceId"]

        resource_tags = {}

        if "Tags" in instance:
            resource_tags = {
                tag["Key"]: tag["Value"]
                for tag in instance["Tags"]
            }

        missing_tags = []

        for required_tag in required_tags:

            if required_tag not in resource_tags:
                missing_tags.append(required_tag)

        if missing_tags:

            print(
                f"Instance {instance_id} missing tags: {missing_tags}"
            )

        else:

            print(
                f"Instance {instance_id} is compliant"
            )