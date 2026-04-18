from datetime import datetime, date
from random import randrange


class Bird():
    def __init__(self, ID: str, btype: str, birth: str, colors: list, foodtype: str, volume: int):
        self.ID = ID

        if btype not in ["Love Bird", "Budgerigar", "Gouldian Finch", "Zebra Finch"]:
            raise ValueError("Invalid bird type")
        self.btype = btype

        self.birth = birth

        if not colors or not isinstance(colors, list):
            raise ValueError("Invalid bird colors list")
        self.colors = colors

        food = ('Corn', 'Seeds')
        if foodtype not in food:
            raise ValueError("Invalid food type")
        self.foodtype = foodtype

        self.volume = volume
        self.sign = btype[0]

    def get_age(self):
        list_birth = self.birth.split(":")
        list_current_date = str(date.today()).split("-")
        int_birth = int(list_birth[0]) + int(list_birth[1]) * 30 + int(list_birth[2]) * 365
        int_current_date = int(list_current_date[2]) + int(list_current_date[1]) * 30 + int(list_current_date[0]) * 365
        years = (int_current_date - int_birth) // 365
        months = ((int_current_date - int_birth) % 365) // 30
        days = ((int_current_date - int_birth) % 365) % 30
        return str(years) + "Y," + str(months) + "M," + str(days) + "D"

    def get_type(self):
        return self.btype

    def get_colors(self):
        return self.colors

    def get_food_type(self):
        return self.foodtype

    def get_volume(self):
        return self.volume

    def get_sign(self):
        return self.sign

    def __str__(self):
        return "Bird ID: " + self.ID + "\nBird type: " + self.get_type() + "\nAge: " + self.get_age() \
            + "\nColors: " + str(self.get_colors()) + "\nFood type:" + self.get_food_type()

    def __eq__(self, other):
        if not isinstance(other, Bird):
            raise ValueError("The second object is not not a bird")
        return self.btype == other.get_type()

    def __gt__(self, other):
        if not isinstance(other, Bird):
            raise ValueError("The second object is not not a bird")
        return len(self.colors) > len(other.get_colors())

    def __lt__(self, other):
        if not isinstance(other, Bird):
            raise ValueError("The second object is not not a bird")
        return len(self.colors) < len(other.get_colors())


class Finch(Bird):
    def __init__(self, ID: str, btype: str, birth: str, colors: list, volume: int):
        Bird.__init__(self, ID, btype, birth, colors, "Seeds", volume)

    def nest_building(self):
        date_list = self.get_age().split(",")
        years = int(date_list[0][:-1])
        nest = ["|"]
        for n in range(years):
            nest.append("_")
        nest.append("|")
        return nest


class Parrot(Bird):
    def __init__(self, ID: str, btype: str, birth: str, colors: list, volume: int):
        Bird.__init__(self, ID, btype, birth, colors, "Corn", volume)

    def find_nestbox(self):
        date_list = self.get_age().split(",")
        years = int(date_list[0][:-1])
        if years < 2:
            return None
        nest_box = []
        for row in range(years):    # creating an empty matrix with size of (years*years)
            nest_box.append([])
            for col in range(years):
                nest_box[row].append('')

        for row in range(years):    # fill the matrix's frame with '*'
            if row == 0 or row == years - 1:
                for col in range(years):
                    nest_box[row][col] = '*'
            else:
                nest_box[row][0] = '*'
                for col in range(1, years - 1):
                    nest_box[row][col] = ' '
                nest_box[row][years-1] = '*'
        return nest_box


class Zebrafinch(Finch):
    def __init__(self, ID: str, birth: str, colors: list):
        Finch.__init__(self, ID, "Zebra Finch", birth, colors, 27000)
        for i in range(len(self.colors)):
            if self.colors[i] not in ("Brown", "Orange", "Black", "White"):
                raise ValueError("Invalid colors list")

    def get_type(self):
        return self.btype

    def jump(self):
        return "I like to jump"


class Gouldianfinch(Finch):
    def __init__(self, ID: str, birth: str, colors: list):
        Finch.__init__(self, ID, "Gouldian Finch", birth, colors, 96000)
        for i in range(len(self.colors)):
            if self.colors[i] not in ("Red", "Green", "Blue", "Yellow", "Orange", "Black", "Purple", "White"):
                raise ValueError("Invalid colors list")
        self.singing_strength = randrange(1, 10)

    def get_type(self):
        return self.btype

    def sing(self):
        return ("I like to sing " ,self.singing_strength)   # we asked to return tuple

    def __str__(self):
        return Bird.__str__(self) + "\nSinging strength:" + str(self.singing_strength)


class Budgerigar(Parrot):
    def __init__(self, ID: str, birth: str, colors: list):
        Parrot.__init__(self, ID, "Budgerigar", birth, colors, 96000)
        for i in range(len(self.colors)):
            if self.colors[i] not in ("Green", "Blue", "Yellow", "Gray", "Purple", "White"):
                raise ValueError("Invalid colors list")
        self.tweeting_strength = randrange(1, 10)

    def get_type(self):
        return self.btype

    def tweet(self):
        return ("I like to tweet" ,self.tweeting_strength)   # we asked to return tuple

    def __str__(self):
        return Bird.__str__(self) + "\nTweeting strength:" + str(self.tweeting_strength)


class Lovebird(Parrot):
    def __init__(self, ID: str, birth: str, colors: list):
        Parrot.__init__(self, ID, "Love Bird", birth, colors, 120000)
        for i in range(len(self.colors)):
            if self.colors[i] not in ("Red", "Green", "Blue", "Yellow", "Black", "White"):
                raise ValueError("Invalid colors list")

    def kiss(self):
        return "I like to kiss"


class Cage:
    def __init__(self, ID: str, length: int, depth: int, height: int, color: str):
        if ID != ID.upper():
            raise ValueError("Invalid ID")
        self.ID = ID

        self.length = length
        self.depth = depth
        self.height = height

        if color not in ("Silver", "Black", "White"):
            raise ValueError("Invalid cage color")
        self.color = color

        self.bird_inside_cage = []
        cage_map = []
        for h in range(int(height / 10)):
            cage_map.append([])
            for le in range(int(length / 10)):
                cage_map[h].append('#')
        self.cage_map = cage_map

        self.sign = "#"
        self.bird_name = "Empty"
        self.free_space = self.length * self.depth * self.height
        self.cage_is_empty = True

    def add_bird(self, bird):
        if not self.cage_is_empty:
            for i in range(len(self.bird_inside_cage)):
                if not bird.__eq__(self.bird_inside_cage[i]):
                    return False
        if bird.volume > self.free_space:
            return False

        self.sign = bird.btype[0]
        self.bird_name = bird.btype
        self.bird_inside_cage.append(bird)
        self.free_space -= bird.volume
        self.cage_is_empty = False
        for row in range(int(self.height / 10)):    # changes the sign (#) with the sign letter of the bird
            for col in range(int(self.length / 10)):
                self.cage_map[row][col] = self.sign
        return True

    def get_birds(self):
        return self.bird_inside_cage

    def get_num_of_birds(self):
        return len(self.bird_inside_cage)

    def get_cage(self):
        cage_drawing = []
        for i in range(int(self.height / 10)):
            cage_drawing.append(self.sign * int(self.length / 10))
        return cage_drawing

    def get_sign(self):
        return self.sign

    def __str__(self):
        return "Cage ID: " + self.ID + "\nSize: " + "(" + str(self.length) + ", " + str(self.depth) + ", " +\
            str(self.height) + ")" + "\nColor: " + str(self.color) + "\nNum of birds: " +\
            str(len(self.bird_inside_cage)) + "\nBirds type:" + str(self.bird_name)


class Birdroom:
    def __init__(self, length: float, width: float, height: float):
        self.length = length
        self.width = width
        self.height = height
        self.cages_list = []
        self.birds_inside_birdroom = []

        wall_map = []
        for row in range(int(height*10) + 2):   # set an empty bird room wall and add frame to it
            wall_map.append([])
            if row == 0 or row == (int(height*10) + 1):
                for col in range(int(length*10) + 2):
                    wall_map[row].append('-')
            else:
                for col in range(int(length * 10) + 2):
                    wall_map[row].append(' ')
                wall_map[row][0] = "|"
                wall_map[row][int(length*10) + 1] = "|"
        self.wall_map = wall_map

    def get_cages(self):
        return self.cages_list

    def get_birds(self):
        birds_in_birdroom = []
        for cage in self.cages_list:
            for bird in cage.get_birds():
                birds_in_birdroom.append(bird)
        return birds_in_birdroom

    def get_strength(self):
        total_strength = 0
        for bird in self.get_birds():
            if bird.get_btype() == "Zebra Finch" or "Love Bird":
                break
            if bird.get_btype() == "Gouldian Finch":
                total_strength += bird.singing_strength
            if bird.get_btype() == "Budgerigar":
                total_strength += bird.tweeting_strength
        return total_strength

    def add_cage(self, cage, x: float, y: float):   # 1sq = 1dc = 10cm
        room_x_sq = int(self.length * 10)   # m --> dc
        room_y_sq = int(self.height * 10)   # m --> dc
        x_start_sq = int(x * 10)    # m --> dc
        y_start_sq = int(y * 10)    # m --> dc
        cage_x_sq = int(cage.length / 10)   # cm --> dc
        cage_y_sq = int(cage.height / 10)   # cm --> dc

        if x_start_sq + cage_x_sq > room_x_sq or y_start_sq+cage_y_sq > room_y_sq:  # if the cage get out of the frame
            return False

        for row in range(y_start_sq + 1, y_start_sq + 1 + cage_y_sq):   # if the cage cannot fit in because of another
            # cage already exist
            for col in range(x_start_sq + 1, x_start_sq + 1 + cage_x_sq):
                if self.wall_map[row][col] != ' ':
                    return False

        self.cages_list.append(cage)    # update bird room cages list
        for bird in cage.get_birds():   # update bird room birds list
            self.birds_inside_birdroom.append(bird)

        for row in range(y_start_sq + 1, y_start_sq + 1 + cage_y_sq):   # update the wall map of the bird room
            for col in range(x_start_sq + 1, x_start_sq + 1 + cage_x_sq):
                self.wall_map[row][col] = cage.get_sign()
        return True

    def get_birdroom(self):
        return self.wall_map

    def get_most_colorful(self):
        most_colorful = self.birds_inside_birdroom[0]
        for bird in self.birds_inside_birdroom:
            if bird.__gt__(most_colorful):
                most_colorful = bird
        return most_colorful

    def __str__(self):
        return "Size: " + "(" + str(self.length) + ", " + str(self.width) + ", " + str(self.height) + ")" +\
            "\nNum of cages: " + str(len(self.cages_list)) + "\nNum of birds: " + str(len(self.get_birds()))
