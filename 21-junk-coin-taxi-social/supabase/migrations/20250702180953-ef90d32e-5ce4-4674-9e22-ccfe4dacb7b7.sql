-- Create fixed routes table
CREATE TABLE public.fixed_routes (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  start_location TEXT NOT NULL,
  end_location TEXT NOT NULL,
  distance_km DECIMAL(8,2),
  estimated_duration_minutes INTEGER,
  market_price DECIMAL(10,2),
  our_price DECIMAL(10,2),
  currency TEXT DEFAULT 'CNY',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.fixed_routes ENABLE ROW LEVEL SECURITY;

-- Create policies for public access to active routes
CREATE POLICY "Anyone can view active fixed routes" 
ON public.fixed_routes 
FOR SELECT 
USING (is_active = true);

-- Add fixed_route_id to ride_requests table
ALTER TABLE public.ride_requests 
ADD COLUMN fixed_route_id UUID REFERENCES public.fixed_routes(id);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_fixed_routes_updated_at
BEFORE UPDATE ON public.fixed_routes
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();